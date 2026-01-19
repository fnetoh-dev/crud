class User < ApplicationRecord
    enum role: { user: 0, admin: 1 }

    # Sanitization example
    before_validation :normalize_email
    before_validation :normalize_name

    validates :name, presence: true, length: { minimum: 2, maximum: 120 }
    validates :email, presence: true, length: { maximum: 255 },
                                      format: { with: URI::MailTo::EMAIL_REGEXP },
                                      uniqueness: { case_sensitive: false }
    #Role validation to grant that role is always present to user
    validates :role, presence: true

    # In Ruby, boolean always should be validated for inclusion to grant that never is nil and boolean value is real   
    validates :active, inclusion: { in: [true, false] }

    # Scopes works as reusable query fragments
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :admins, -> { where(role: roles[:admin]) }

    
    private

    def normalize_email
        self.email =  email.to_s.strip.downcase #to_s -> avoid nil errors | strip -> remove leading/trailing spaces | downcase -> standard email format
    end

    def normalize_name
        self.name = name.to_s.strip.titleize #titleize -> Capitalize each first letter of word
    end

end

