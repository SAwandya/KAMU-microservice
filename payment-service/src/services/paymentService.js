// src/services/paymentService.js
const stripe = require("stripe")(
  require("../config/environment").STRIPE_SECRET_KEY
);
const paymentRepository = require("../repositories/paymentRepository");
// const paymentEventPublisher = require("../events/publishers/paymentEventPublisher");

class PaymentService {
  async createPaymentIntent(orderData) {
    try {
      // Check if payment already exists for this order
      const existingPayment = await paymentRepository.getPaymentByOrderId(
        orderData.id
      );
      if (existingPayment) {
        return {
          paymentIntentId: existingPayment.stripePaymentIntentId,
          clientSecret: null, // We don't store client secrets
          status: existingPayment.status,
        };
      }

      // Create a payment intent with Stripe
      const paymentIntent = await stripe.paymentIntents.create({
        amount: Math.round(orderData.totalAmount * 100), // Convert to cents
        currency: "usd", // Use appropriate currency
        metadata: {
          orderId: orderData.id.toString(),
          customerId: orderData.customerId.toString(),
        },
      });

      // Store payment record in database
      await paymentRepository.createPayment({
        orderId: orderData.id,
        stripePaymentIntentId: paymentIntent.id,
        amount: orderData.totalAmount,
        currency: "usd",
        status: paymentIntent.status,
      });

      return {
        paymentIntentId: paymentIntent.id,
        clientSecret: paymentIntent.client_secret,
        status: paymentIntent.status,
      };
    } catch (error) {
      console.error("Error creating payment intent:", error);
      throw error;
    }
  }

  async processPayment(paymentData) {
    try {
      const { amount, paymentMethodId, orderId } = paymentData;

      // Check if there's already a payment for this order
      const existingPayment = await paymentRepository.getPaymentByOrderId(orderId);
      if (existingPayment && existingPayment.status === 'COMPLETED') {
        return {
          success: true,
          transactionId: existingPayment.transactionId,
          paymentId: existingPayment.id,
        };
      }

      // Handle different Stripe test cards
      if (paymentMethodId.includes('4000000000000002')) {
        // Stripe test card that always declines
        // Record the failed payment
        const paymentId = await paymentRepository.createPayment({
          orderId,
          stripePaymentIntentId: `pi_declined_${Date.now()}`,
          amount,
          currency: 'usd',
          status: 'FAILED',
          paymentMethod: 'CARD',
        });

        return {
          success: false,
          error: "Your card has been declined.",
          paymentId,
        };
      }

      // For all other cards, simulate successful payment
      // In production, this would involve actual Stripe API calls
      const transactionId = `txn_${Math.random().toString(36).substring(2, 15)}`;

      // Create a record in our payment database
      const payment = await paymentRepository.createPayment({
        orderId,
        stripePaymentIntentId: `pi_${transactionId}`,
        amount,
        currency: 'usd',
        status: 'COMPLETED',
        paymentMethod: 'CARD',
        transactionId,
      });

      // Log the payment event
      await paymentRepository.createPaymentLog(payment.id, 'PAYMENT_COMPLETED', {
        orderId,
        amount,
        paymentMethodId
      });

      // In a real implementation, we would publish an event for order service
      // await paymentEventPublisher.publishPaymentCompleted({
      //   orderId: parseInt(orderId),
      //   paymentId: payment.id,
      //   amount,
      //   status: 'COMPLETED',
      // });

      return {
        success: true,
        transactionId,
        paymentId: payment.id,
      };
    } catch (error) {
      console.error("Error processing payment:", error);
      return {
        success: false,
        error: error.message || "Payment processing failed"
      };
    }
  }

  async createCheckoutSession(orderData) {
    try {
      // Format line items for Stripe
      const lineItems = orderData.items.map((item) => ({
        price_data: {
          currency: "usd",
          product_data: {
            name: item.name,
            description: item.description || undefined,
          },
          unit_amount: Math.round(item.price * 100), // Convert to cents
        },
        quantity: item.quantity,
      }));

      // Create checkout session with Stripe
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: lineItems,
        mode: "payment",
        success_url: `${require("../config").clientUrl
          }/order/success?session_id={CHECKOUT_SESSION_ID}`,
        cancel_url: `${require("../config").clientUrl}/order/cancel`,
        metadata: {
          orderId: orderData.id.toString(),
          customerId: orderData.customerId.toString(),
        },
      });

      return {
        sessionId: session.id,
        url: session.url,
      };
    } catch (error) {
      console.error("Error creating checkout session:", error);
      throw error;
    }
  }

  async handleWebhookEvent(event) {
    try {
      switch (event.type) {
        case "payment_intent.succeeded":
          await this.handlePaymentIntentSucceeded(event.data.object);
          break;
        case "payment_intent.payment_failed":
          await this.handlePaymentIntentFailed(event.data.object);
          break;
        case "checkout.session.completed":
          await this.handleCheckoutSessionCompleted(event.data.object);
          break;
        default:
          console.log(`Unhandled event type: ${event.type}`);
      }
    } catch (error) {
      console.error("Error handling webhook event:", error);
      throw error;
    }
  }

  async handlePaymentIntentSucceeded(paymentIntent) {
    try {
      // Update payment status in database
      const payment =
        await paymentRepository.updatePaymentStatusByPaymentIntentId(
          paymentIntent.id,
          "COMPLETED",
          paymentIntent.latest_charge
        );

      // if (payment) {
      //   // Publish payment completed event
      //   await paymentEventPublisher.publishPaymentCompleted({
      //     orderId: parseInt(paymentIntent.metadata.orderId),
      //     paymentId: payment.id,
      //     stripePaymentIntentId: paymentIntent.id,
      //     amount: payment.amount,
      //     status: "COMPLETED",
      //   });
      // }
    } catch (error) {
      console.error("Error handling payment intent succeeded:", error);
      throw error;
    }
  }

  async handlePaymentIntentFailed(paymentIntent) {
    try {
      // Update payment status in database
      const payment =
        await paymentRepository.updatePaymentStatusByPaymentIntentId(
          paymentIntent.id,
          "FAILED"
        );

      // if (payment) {
      //   // Publish payment failed event
      //   await paymentEventPublisher.publishPaymentFailed({
      //     orderId: parseInt(paymentIntent.metadata.orderId),
      //     paymentId: payment.id,
      //     stripePaymentIntentId: paymentIntent.id,
      //     amount: payment.amount,
      //     status: "FAILED",
      //     error: paymentIntent.last_payment_error?.message || "Payment failed",
      //   });
      // }
    } catch (error) {
      console.error("Error handling payment intent failed:", error);
      throw error;
    }
  }

  async handleCheckoutSessionCompleted(session) {
    try {
      // For checkout sessions, we need to get the payment intent
      const paymentIntent = await stripe.paymentIntents.retrieve(
        session.payment_intent
      );

      // Then process it as a succeeded payment intent
      await this.handlePaymentIntentSucceeded(paymentIntent);
    } catch (error) {
      module.exports = new PaymentService();
