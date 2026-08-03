class EmployeeRegistrationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  def self.model_name
    ActiveModel::Name.new(self, nil, "User")
  end

  # Campos de User
  attribute :first_name, :string
  attribute :last_name, :string
  attribute :email_address, :string
  attribute :active, :boolean, default: true
  attribute :role, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  # Campos de Employee
  attribute :hourly_rate, :decimal
  attribute :birth_date, :date
  attribute :gender, :string
  attribute :admission_date, :date
  attribute :contract_type, :string
  attribute :salary, :decimal
  attribute :position, :string
  attribute :phone_number, :string
  attribute :rg, :string
  attribute :cpf, :string

  attribute :user_id, :integer # presente só em edição

  validates :first_name, :last_name, :email_address, presence: true
  validates :password, presence: true, length: { minimum: 4}, if: -> { user_id.blank? }
  validates :cpf, :rg, :birth_date, presence: true

  def self.from_user(user)
    new(
      user_id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email_address: user.email_address,
      active: user.active,
      role: user.role,
      hourly_rate: user.employee&.hourly_rate,
      birth_date: user.employee&.birth_date,
      gender: user.employee&.gender,
      admission_date: user.employee&.admission_date,
      contract_type: user.employee&.contract_type,
      salary: user.employee&.salary,
      position: user.employee&.position,
      phone_number: user.employee&.phone_number,
      rg: user.employee&.rg,
      cpf: user.employee&.cpf
    )
  end

  def persisted?
    user_id.present?
  end

  def admin_role?
    role == "admin"
  end

  def employee_role?
    role == "employee"
  end

  def clt?
    contract_type == "clt"
  end

  def freelancer?
    contract_type == "freelancer"
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      persisted? ? update_existing : create_new
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.record.errors.full_messages.join(", "))
    false
  end

  private

  def create_new
    user = User.create!(user_attrs)
    user.build_employee(employee_attrs).save!
  end

  def update_existing
    user = User.find(user_id)
    user.update!(user_attrs)
    user.employee.update!(employee_attrs)
  end

  def user_attrs
    {
      first_name: first_name, last_name: last_name, email_address: email_address,
      active: active, role: role, password: password, password_confirmation: password_confirmation
    }.compact_blank
  end

  def employee_attrs
    {
      hourly_rate: hourly_rate, birth_date: birth_date, gender: gender,
      admission_date: admission_date, contract_type: contract_type,
      salary: salary, position: position, phone_number: phone_number, rg: rg, cpf: cpf
    }.compact_blank
  end
end
