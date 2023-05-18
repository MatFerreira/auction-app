require 'rails_helper'

describe 'Usuário acessa lotes vencidos' do
  it 'com sucesso' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    publisher = Admin.create!(email: 'jorge@leilaodogalpao.com.br', cpf: '38027134005', password:'password')

    lot = Lot.create!(code:'ABC123456', initial_date: (Date.yesterday), limit_date: (Date.today + 10.days),
                      minimum_bid: 25, minimum_bid_increment: 5, status: :published,
                      creator: creator, publisher: publisher)

    first_item = Item.create!(name: 'micro-ondas', description: 'bom estado', weight: 5000,
                        width: 60, height: 30, depth: 30, product_category: 'eletrodoméstico',
                        lot: lot)

    second_item = Item.create!(name: 'armário', description: 'quatro portas', weight: 25000,
                        width: 250, height: 200, depth: 100, product_category: 'mobilha',
                        lot: lot)
    user = User.create!(email: 'pedro@mail.com', cpf: '74316786067', password: 'pedro123')
    bid = Bid.create!(value: 30, lot: lot, user: user)

    travel 15.days
    lot.update!(status: 'closed')
    login_as(user, scope: :user)
    visit owned_lots_path

    expect(page).to have_content 'Lote ABC123456'
  end
end
