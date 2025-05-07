class User {
  constructor(id, fullName, email, password, tokens = []) {
    this.id = id;
    this.fullName = fullName;
    this.email = email;
    this.password = password;
    this.tokens = tokens; // Array to store refresh token hashes
  }
}

module.exports = User;
