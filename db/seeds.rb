data = [
  {
    name: 'John',
    email: 'john@example.com',
    password: 'Password@123',
    team: {
      name: 'Team A'
    },
    balance: 5500000
  },
  {
    name: 'Jane',
    email: 'jane@example.com',
    password: 'Password@123',
    team: {
      name: 'Team A'
    },
    balance: 3500000
  },
  {
    name: 'June',
    email: 'june@example.com',
    password: 'Password@123',
    team: {
      name: 'Team B'
    },
    balance: 450000
  }
]



data.each do |row|
  user = User.find_by(email: row[:email])

  unless user.present?
    user = User.create(email: row[:email], password: row[:password])

    subject = Subject.create(name: row[:name], subjectable_id: user.id, subjectable_type: 'User')

    transaction = PaymentTransaction.create(amount: row[:balance], subject_id: subject.id, transaction_type: 'credit', transaction_time: Time.now, notes: 'Initial Balance')
  end

  team = Team.where(name: row[:team][:name]).first

  unless team.present?
    team = Team.create(name: row[:team][:name])
  end

  user.reload
  user.team_id = team.id
  user.save!
end