class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } , length: { minimum: 3 }
    validates :password, presence: true, length: { minimum: 6 }

    # has_many :courses, dependent: :destroy

end
