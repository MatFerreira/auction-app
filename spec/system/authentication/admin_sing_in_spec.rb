require 'rails_helper'

describe 'Administrador se autentica' do
  it 'com sucesso' do
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', password: 'password', cpf: '29973194047' )

    visit new_admin_session_path
    within 'main > form' do
      fill_in 'E-mail', with: 'fulano@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    within 'nav' do
      expect(page).to have_content 'fulano@leilaodogalpao.com.br'
      expect(page).to have_button 'Sair'
    end
  end

  it 'e encerra a sessão' do
    admin = Admin.create!(email: 'fulano@leilaodogalpao.com.br', password: 'password', cpf: '29973194047' )

    visit new_admin_session_path
    within 'main > form' do
      fill_in 'E-mail', with: 'fulano@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    within 'nav' do
      click_on 'Sair'
    end

    expect(page).not_to have_content 'fulano@leilaodogalpao.com.br'
    expect(page).not_to have_button 'Sair'
  end
end
