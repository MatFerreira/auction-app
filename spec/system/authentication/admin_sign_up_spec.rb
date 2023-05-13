require 'rails_helper'

describe 'Administrador se cadastra' do
  it 'com sucesso' do
    visit new_admin_registration_path
    fill_in 'CPF', with: '29973194047'
    fill_in 'E-mail', with: 'fulano@leilaodogalpao.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso'
    within 'nav' do
      expect(page).to have_content 'fulano@leilaodogalpao.com.br'
    end
  end
end
