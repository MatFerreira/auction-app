require 'rails_helper'

describe 'Administrador acessa detalhes de um item' do
  it 'e visualiza informações adicionais' do
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'fulano')
    item = Item.create!(name: 'micro-ondas', description: 'bom estado', weight: 5000,
                        width: 60, height: 30, depth: 30, product_category: 'eletrodoméstico')

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Itens'
    click_on "Item: #{item.code}"

    expect(current_path).to eq item_path(item)
    expect(page).to have_content 'Nome: micro-ondas'
    expect(page).to have_content 'Descrição: bom estado'
    expect(page).to have_content 'Peso: 5000 g'
    expect(page).to have_content 'Largura: 60 cm'
    expect(page).to have_content 'Altura: 30 cm'
    expect(page).to have_content 'Profundidade: 30 cm'
    expect(page).to have_content 'Categoria do Produto: eletrodoméstico'
  end
end
