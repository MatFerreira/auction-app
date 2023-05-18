require 'rails_helper'

describe 'Administrador cadastra novo item' do
  it 'com sucesso' do
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'fulano')

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Itens'
    click_on 'Cadastrar Item'
    fill_in 'Nome', with: 'TV'
    fill_in 'Descrição', with: '42 polegadas'
    fill_in 'Peso', with: 5000
    fill_in 'Largura', with: 92
    fill_in 'Altura', with: 50
    fill_in 'Profundidade', with: 5
    fill_in 'Categoria do Produto', with: 'Eletrônico'
    click_on 'Enviar'

    expect(page).to have_content 'Item cadastrado com sucesso.'
    expect(page).to have_content "Item: ABCDE12345"
    expect(page).to have_content 'Nome: TV'
    expect(page).to have_content 'Descrição: 42 polegadas'
    expect(page).to have_content 'Peso: 5000 g'
    expect(page).to have_content 'Largura: 92 cm'
    expect(page).to have_content 'Altura: 50 cm'
    expect(page).to have_content 'Profundidade: 5 cm'
    expect(page).to have_content 'Categoria do Produto: Eletrônico'
  end

  it 'com informação incompleta' do
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'fulano')

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Itens'
    click_on 'Cadastrar Item'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Peso', with: 5000
    fill_in 'Largura', with: 92
    fill_in 'Altura', with: 50
    fill_in 'Profundidade', with: 5
    fill_in 'Categoria do Produto', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'O item não pôde ser cadastrado.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Categoria do Produto não pode ficar em branco'
  end
end
