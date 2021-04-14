FactoryBot.define do
  sequence :uid do |n|
    "#{n}"
  end
  factory :oauth_app, class: 'Doorkeeper::Application' do
    name {'test'}
    uid
    secret {'1234'}
    redirect_uri {'urn:ietf:wg:oauth:2.0:oob'}
  end
end
