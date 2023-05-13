require 'rails_helper'

describe 'Administrador acessa index de itens' do
  it 'vazio' do
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'fulano')

    login_as admin
    visit root_path
    click_on 'Itens'

    expect(page).to have_content 'Não há itens cadastrados'
  end

  it 'com registros' do
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'fulano')
    first_item = Item.create!(name: 'micro-ondas', description: 'bom estado', weight: 5000,
                              width: 60, height: 30, depth: 30, product_category: 'eletrodoméstico',
                              code: '12345abcde')

    second_item = Item.create!(name: 'armário', description: 'quatro portas', weight: 25000,
                              width: 250, height: 200, depth: 100, product_category: 'mobilha',
                              code: 'abcde12345')
    login_as admin
    visit root_path
    click_on 'Itens'

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
