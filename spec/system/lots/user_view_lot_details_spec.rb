require 'rails_helper'

describe 'Usuário acessa detalhes de um lote' do
  it 'com sucesso' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    publisher = Admin.create!(email: 'jorge@leilaodogalpao.com.br', cpf: '38027134005', password:'password')

    lot = Lot.create!(code:'ABC123456', initial_date: (Date.today - 5.days), limit_date: (Date.today + 15.days),
                      minimum_bid: 25, minimum_bid_increment: 5, status: :published,
                      creator: creator, publisher: publisher)

    first_item = Item.create!(name: 'micro-ondas', description: 'bom estado', weight: 5000,
                        width: 60, height: 30, depth: 30, product_category: 'eletrodoméstico',
                        lot: lot)

    second_item = Item.create!(name: 'armário', description: 'quatro portas', weight: 25000,
                        width: 250, height: 200, depth: 100, product_category: 'mobilha',
                        lot: lot)

    visit root_path
    click_on 'Lote ABC123456'

    within 'section#lot-info' do
      expect(page).to have_content 'Lote ABC123456'
      expect(page).to have_content "Data de início: #{I18n.l lot.initial_date}"
      expect(page).to have_content "Data limite: #{I18n.l lot.limit_date}"
      expect(page).to have_content 'Lance mínimo: R$ 25,00'
      expect(page).to have_content 'Diferença mínima entre lances: R$ 5,00'
    end
    within 'section#lot-items' do
      expect(page).to have_content "Item: #{first_item.code}"
      expect(page).to have_content "Nome: #{first_item.name}"
      expect(page).to have_content "Descrição: #{first_item.description}"
      expect(page).to have_content "Categoria do Produto: #{first_item.product_category}"

      expect(page).to have_content "Item: #{second_item.code}"
      expect(page).to have_content "Nome: #{second_item.name}"
      expect(page).to have_content "Descrição: #{second_item.description}"
      expect(page).to have_content "Categoria do Produto: #{second_item.product_category}"
    end
  end
end
