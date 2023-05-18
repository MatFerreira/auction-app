require 'rails_helper'

describe 'Usuário faz lance' do
  it 'com sucesso' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    publisher = Admin.create!(email: 'jorge@leilaodogalpao.com.br', cpf: '38027134005', password:'password')

    initial_date = I18n.l(5.days.ago.to_date)
    limit_date = I18n.l(20.days.from_now.to_date)
    lot = Lot.create!(code: 'EFG123456', initial_date: initial_date, limit_date: limit_date,
                      minimum_bid: 250, minimum_bid_increment: 25,
                      status: :published, creator: creator, publisher: publisher)

    first_item = Item.create!(name: 'micro-ondas', description: 'bom estado', weight: 5000,
                              width: 60, height: 30, depth: 30, product_category: 'eletrodoméstico')

    second_item = Item.create!(name: 'armário', description: 'quatro portas', weight: 25000,
                                width: 250, height: 200, depth: 100, product_category: 'mobilha')

    user = User.create!(email: 'pedro@mail.com', cpf: '74316786067', password: 'pedro123')

    login_as(user, scope: :user)
    visit lot_path(lot.id)
    within '#bid-form' do
      fill_in 'Valor', with: 250
      click_on 'Enviar'
    end

    within '#bid-info' do
      expect(page).to have_content "Usuário: #{user.email}"
      expect(page).to have_content 'Valor: R$ 250,00'
    end
  end

  it 'inválido' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    publisher = Admin.create!(email: 'jorge@leilaodogalpao.com.br', cpf: '38027134005', password:'password')

    initial_date = I18n.l(5.days.ago.to_date)
    limit_date = I18n.l(20.days.from_now.to_date)
    lot = Lot.create!(code: 'EFG123456', initial_date: initial_date, limit_date: limit_date,
                      minimum_bid: 250, minimum_bid_increment: 25,
                      status: :published, creator: creator, publisher: publisher)

    first_item = Item.create!(name: 'micro-ondas', description: 'bom estado', weight: 5000,
                              width: 60, height: 30, depth: 30, product_category: 'eletrodoméstico')

    second_item = Item.create!(name: 'armário', description: 'quatro portas', weight: 25000,
                                width: 250, height: 200, depth: 100, product_category: 'mobilha')

    user = User.create!(email: 'pedro@mail.com', cpf: '74316786067', password: 'pedro123')

    login_as(user, scope: :user)
    visit lot_path(lot.id)
    within '#bid-form' do
      fill_in 'Valor', with: 200
      click_on 'Enviar'
    end

    within '#bid-info' do
      expect(page).to have_content "Não há lances neste lote"
    end
    expect(page).to have_content 'Lance inválido.'
  end
end
