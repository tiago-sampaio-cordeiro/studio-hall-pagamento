# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

admin_email = ENV.fetch("ADMIN_EMAIL")
admin_password = ENV.fetch("ADMIN_PASSWORD")

admin = User.find_or_initialize_by(email_address: admin_email)

if admin.persisted?
  puts "Admin já existe: #{admin_email}"
else
  admin.assign_attributes(
    first_name: "Admin",
    last_name: "Sistema",
    active: true,
    role: "admin",
    password: admin_password,
    password_confirmation: admin_password
  )

  if admin.save
    puts "Admin criado com sucesso!"
  else
    puts "Falha ao criar admin: #{admin.errors.full_messages.join(', ')}"
  end
end

# # cria usuários e employees
# ROLES = %i[employee admin]
# CONTRACT_TYPES = %i[freelancer clt]
#
# 10.times do |i|
#   puts "Criando user #{i}"
#
#   role = ROLES.sample
#   contract_type = CONTRACT_TYPES.sample
#
#   user = User.create!(
#     email_address: Faker::Internet.unique.email,
#     password: "1234",
#     role: role,
#     active: true,
#     first_name: Faker::Artist.name,
#     last_name: Faker::Name.last_name
#   )
#
#   employee_attributes = {
#     user: user,
#     address: Faker::Address.full_address,
#     admission_date: Faker::Date.between(from: "2024-01-01", to: Date.current),
#     birth_date: Faker::Date.between(from: "1985-01-01", to: "2005-12-31"),
#     cnpj: Faker::IdNumber.brazilian_citizen_number(formatted: false),
#     contract_type: contract_type,
#     ctps: Faker::IdNumber.brazilian_citizen_number(formatted: false),
#     gender: Faker::Gender.binary_type,
#     phone_number: Faker::PhoneNumber.cell_phone,
#     pis: Faker::IdNumber.brazilian_citizen_number(formatted: false),
#     pix_key: Faker::Number.decimal_part(digits: 10),
#     position: Faker::Job.position,
#     rg: Faker::Number.decimal_part(digits: 10),
#     cpf: Faker::IdNumber.brazilian_citizen_number,
#     mother_name: Faker::Artist.name,
#     mother_last_name: Faker::Name.last_name,
#     emergency_phone_number: Faker::PhoneNumber.cell_phone,
#     nationality: Faker::Nation.nationality,
#     city_born: Faker::Address.city,
#     uf_born: Faker::Address.country_code,
#     blood_group: Faker::Blood.rh_factor,
#     allergies: "nenhuma",
#     driver_license: Faker::DrivingLicence.british_driving_licence,
#     driver_license_category: "AB",
#     driver_license_number: Faker::IdNumber.brazilian_citizen_number,
#     cep: Faker::Address.zip_code,
#     house_number: Faker::Address.building_number,
#     neighborhood: Faker::Address.street_name,
#     city: Faker::Address.city,
#     uf_live: Faker::Address.country_code,
#     reference: Faker::Commerce.brand
#   }
#
#   if contract_type == :clt
#     employee_attributes[:salary] = Faker::Number.between(from: 2000, to: 8000)
#     employee_attributes[:hourly_rate] = nil
#   else
#     employee_attributes[:hourly_rate] = Faker::Number.between(from: 30, to: 150)
#     employee_attributes[:salary] = nil
#   end
#
#   employee = Employee.create!(employee_attributes)
#
#   # 🔥 Registro de ponto para os dois tipos
#   5.downto(1) do |d|
#     date = d.days.ago.to_date
#
#     clock_in = Faker::Time.between(
#       from: date.to_time + 8.hours,
#       to: date.to_time + 9.hours
#     )
#
#     clock_out = Faker::Time.between(
#       from: clock_in + 8.hours,
#       to: clock_in + 9.hours
#     )
#
#     TimePunch.create!(employee: employee, punched_at: clock_in, kind: 0)
#     TimePunch.create!(employee: employee, punched_at: clock_out, kind: 1)
#   end
# end
#
# puts "#{User.count} usuários criados"
# puts "#{Employee.count} employees criados"
# puts "#{TimePunch.count} registros de ponto criados"

