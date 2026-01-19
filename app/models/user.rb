class User < ApplicationRecord
    enum role: { user: 0, admin: 1 }

    before_validation :normalize_email

    validates :name, presence: true, length: { minimum: 2 }
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
    validates :role, presence: true
    validates :active, inclusion: { in: [true, false] }

    
    private

    def normalize_email
        self.email =  email.to_s.strip.downcase
    end
end
