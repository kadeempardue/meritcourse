class Meritadmin::AdminUser < ApplicationRecord
  self.table_name = "admin_users"
  acts_as_tenant(:tenant)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates_uniqueness_to_tenant %i[first_name last_name email]

  def name
    "#{first_name} #{last_name}"
  end
end
