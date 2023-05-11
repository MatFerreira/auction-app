require 'rails_helper'

describe 'Usuário edita item' do
  it 'com sucesso' do
    item = Item.create!(name: 'micro-ondas', description: 'bom estado',
                        weight: 5000, width: 60, height: 30, depth: 30,
                        product_category: 'eletrodoméstico')

    visit root_path
    click_on 'Itens'
    click_on "Item: #{item.code}"
    click_on 'Editar'
    fill_in 'Nome', with: 'geladeira'
    fill_in 'Descrição', with: 'frost free'
    fill_in 'Peso', with: 25000
    fill_in 'Largura', with: 150
    fill_in 'Altura', with: 180
    fill_in 'Profundidade', with: 100
    click_on 'Enviar'

    expect(current_path).to eq item_path(item)
    expect(page).to have_content 'Nome: geladeira'
    expect(page).to have_content 'Descrição: frost free'
    expect(page).to have_content 'Peso: 25000 g'
    expect(page).to have_content 'Largura: 150 cm'
    expect(page).to have_content 'Altura: 180 cm'
    expect(page).to have_content 'Profundidade: 100 cm'
    expect(page).to have_content 'Categoria do Produto: eletrodoméstico'
  end

  it 'com dados inválidos' do
    item = Item.create!(name: 'micro-ondas', description: 'bom estado',
                        weight: 5000, width: 60, height: 30, depth: 30,
                        product_category: 'eletrodoméstico')

    visit root_path
    click_on 'Itens'
    click_on "Item: #{item.code}"
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Categoria do Produto', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'O item não pôde ser atualizado.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Categoria do Produto não pode ficar em branco'
  end
end
