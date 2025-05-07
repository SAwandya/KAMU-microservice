class User {
  constructor(id, fullName, email, password, role, tokens = []) {
    this.id = id;
    this.fullName = fullName;
    this.email = email;
    this.password = password;
    this.role = role; // Role of the user (e.g., customer, rider)
    this.tokens = tokens; // Array to store refresh token hashes
  }
}

module.exports = User;
