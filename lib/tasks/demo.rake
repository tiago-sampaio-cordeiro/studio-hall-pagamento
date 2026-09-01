namespace :demo do
  desc "Cria funcionários de teste com cenários variados de horas trabalhadas, pra testar as dashboards"
  task seed_employees: :environment do
    range = Time.zone.now.beginning_of_month..Time.zone.now.end_of_month

    # Cria os punches de um funcionário: até 2 turnos de 4h por dia (manhã + tarde),
    # nunca repetindo dia — evita duplicar punched_at e respeita a trava de turno máximo
    create_punches = lambda do |employee:, total_hours:|
      next if total_hours.zero?

      hours_created = 0
      day = range.first.to_date

      while hours_created < total_hours && day <= range.last.to_date
        hours_today = [total_hours - hours_created, 8].min

        morning_hours = [hours_today, 4].min
        if morning_hours > 0
          start_time = day.to_time.change(hour: 8, min: 0, sec: 0)
          end_time = start_time + morning_hours.hours
          TimePunch.create!(employee: employee, kind: :clock_in, punched_at: start_time)
          TimePunch.create!(employee: employee, kind: :clock_out, punched_at: end_time)
          hours_created += morning_hours
        end

        afternoon_hours = [hours_today - morning_hours, 4].min
        if afternoon_hours > 0
          start_time = day.to_time.change(hour: 13, min: 0, sec: 0)
          end_time = start_time + afternoon_hours.hours
          TimePunch.create!(employee: employee, kind: :clock_in, punched_at: start_time)
          TimePunch.create!(employee: employee, kind: :clock_out, punched_at: end_time)
          hours_created += afternoon_hours
        end

        day += 1.day
      end

      if hours_created < total_hours
        puts "  ⚠️  Só coube #{hours_created}h de #{total_hours}h pedidas (mês não tem dias suficientes)"
      end
    end

    scenarios = [
      { label: "Abaixo da meta",          contract: "clt",        hours: 120, salary: 3000.0, hourly_rate: nil },
      { label: "Na meta exata",           contract: "clt",        hours: 176, salary: 3000.0, hourly_rate: nil },
      { label: "Acima da meta",           contract: "clt",        hours: 200, salary: 3000.0, hourly_rate: nil },
      { label: "Freelancer poucas horas", contract: "freelancer", hours: 40,  salary: nil,    hourly_rate: 50.0 },
      { label: "Freelancer muitas horas", contract: "freelancer", hours: 220, salary: nil,    hourly_rate: 50.0 },
      { label: "Sem pontos batidos",      contract: "clt",        hours: 0,   salary: 3000.0, hourly_rate: nil }
    ]

    scenarios.each_with_index do |scenario, index|
      timestamp = Time.current.to_i

      user = User.create!(
        first_name: "Demo#{index + 1}",
        last_name: scenario[:label],
        email_address: "demo#{index + 1}_#{timestamp}@teste.com",
        password: "12345678",
        password_confirmation: "12345678",
        role: "employee",
        active: true
      )

      employee = user.build_employee(
        birth_date: Date.new(1995, 1, 1),
        rg: "1234567#{index}",
        cpf: "1234567890#{index}",
        gender: "masculino",
        contract_type: scenario[:contract],
        salary: scenario[:salary],
        hourly_rate: scenario[:hourly_rate],
        admission_date: Date.current - 1.year,
        position: "Funcionário de teste"
      )
      employee.save!

      create_punches.call(employee: employee, total_hours: scenario[:hours])

      puts "✅ #{user.first_name} #{user.last_name} (#{scenario[:contract]}) — #{scenario[:hours]}h criadas"
    end

    puts "\n🎉 #{scenarios.size} funcionários de demonstração criados com sucesso!"
  end

  desc "Remove todos os funcionários de demonstração criados por demo:seed_employees"
  task remove_employees: :environment do
    users = User.where("email_address LIKE ?", "demo%@teste.com")
    count = users.count
    users.destroy_all
    puts "🗑️  #{count} funcionário(s) de demonstração removido(s)."
  end
end