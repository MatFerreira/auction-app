require 'rails_helper'

describe 'Administrador cadastra novo lote' do
  it 'com sucesso' do
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    initial_date = I18n.l(5.days.ago.to_date)
    limit_date = I18n.l(20.days.from_now.to_date)

    login_as(admin, scope: :admin)
    visit new_lot_path
    fill_in 'Código', with: 'EFG123456'
    fill_in 'Data de início', with: initial_date
    fill_in 'Data limite', with: limit_date
    fill_in 'Lance mínimo', with: 250
    fill_in 'Diferença mínima entre lances', with: 25
    click_on 'Cadastrar'

    expect(page).to have_content 'Lote EFG123456'
    expect(page).to have_content "Data de início: #{initial_date}"
    expect(page).to have_content "Data limite: #{limit_date}"
    expect(page).to have_content 'Lance mínimo: R$ 250,00'
    expect(page).to have_content 'Diferença mínima entre lances: R$ 25,00'
  end

  it 'e adiciona items' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    publisher = Admin.create!(email: 'jorge@leilaodogalpao.com.br', cpf: '38027134005', password:'password')

    initial_date = I18n.l(5.days.ago.to_date)
    limit_date = I18n.l(20.days.from_now.to_date)
    lot = Lot.create!(code: 'EFG123456', initial_date: initial_date, limit_date: limit_date,
                      minimum_bid: 250, minimum_bid_increment: 25, creator: creator)

    first_item = Item.create!(name: 'micro-ondas', description: 'bom estado', weight: 5000,
                              width: 60, height: 30, depth: 30, product_category: 'eletrodoméstico')

    second_item = Item.create!(name: 'armário', description: 'quatro portas', weight: 25000,
                                width: 250, height: 200, depth: 100, product_category: 'mobilha')

    third_item = Item.create!(name: 'panela de pressão', description: 'inox', product_category: 'utensílios')

    login_as(creator, scope: :admin)
    visit lot_path(lot.id)
    page.check first_item.full_description
    page.check third_item.full_description
    click_on 'Atualizar Items'
    logout(:creator)
    login_as(publisher, scope: :admin)
    click_on 'Publicar Lote'
    visit lot_path(lot.id)

    within 'section#lot-items' do
      expect(page).to have_content "Item: #{first_item.code}"
      expect(page).to have_content "Nome: #{first_item.name}"
      expect(page).to have_content "Descrição: #{first_item.description}"
      expect(page).to have_content "Categoria do Produto: #{first_item.product_category}"

      expect(page).to have_content "Item: #{third_item.code}"
      expect(page).to have_content "Nome: #{third_item.name}"
      expect(page).to have_content "Descrição: #{third_item.description}"
      expect(page).to have_content "Categoria do Produto: #{third_item.product_category}"
    end
  end
end
