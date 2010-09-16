Factory.sequence :name do |n|
  "Name_#{n}"
end

Factory.define :account do |u|
  u.name                  'test login'
  u.login                 'test_login'
  u.email                 'test@eggandjam.com'
  u.password              'test123'
  u.password_confirmation 'test123'
end

Factory.define :transaction do |e|
  e.description           'This is a test transaction'
  e.amount                '123'
  e.owner_id              {(Identity.first || Factory(:identity)).id}
end

Factory.define :identity do |f|
  f.name                  {Factory.next(:name)}
  f.account_id            {(Account.first || Factory(:account)).id}
end

Factory.define :recurring_transaction do |e|
  e.from                  Factory(:identity)
  e.to                    Factory(:identity)
  e.type                  'Transaction'
  e.description           'This is a test transaction'
  e.amount                '123'
  e.rec_type              'weekly_6_2' # every other Sunday!
  e.owner_id              {(Identity.first || Factory(:identity)).id}
end