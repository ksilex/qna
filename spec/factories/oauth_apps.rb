FactoryBot.define do
  factory :oauth_app, class: 'Doorkeeper::Application' do
    name {'test'}
    uid {'1234'}
    secret {'1234'}
    redirect_uri {'urn:ietf:wg:oauth:2.0:oob'}
  end
end
