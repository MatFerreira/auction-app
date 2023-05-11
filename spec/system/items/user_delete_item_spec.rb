require 'rails_helper'

describe 'Usuário exclui item' do
  it 'com sucesso' do
    item = Item.create!(name: 'micro-ondas', description: 'bom estado',
                        weight: 5000, width: 60, height: 30, depth: 30,
                        product_category: 'eletrodoméstico')

    visit root_path
    click_on 'Itens'
    click_on "Item: #{item.code}"
    click_on 'Excluir'

    expect(current_path).to eq items_path
    expect(page).to have_content 'Item excluído com sucesso.'
    expect(page).not_to have_content "Item: #{item.code}"
  end
end
