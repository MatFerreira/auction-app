require 'rails_helper'

describe 'Usuário visualiza lotes' do
  it 'em andamento' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    publisher = Admin.create!(email: 'jorge@leilaodogalpao.com.br', cpf: '38027134005', password:'password')

    lot = Lot.create!(code:'ABC123456', initial_date: (Date.today - 5.days), limit_date: (Date.today + 15.days),
                      minimum_bid: 25, minimum_bid_increment: 5,
                      status: :published, creator: creator, publisher: publisher)

    visit root_path

    within 'section#ongoing-lots' do
      expect(page).to have_content 'Lotes em Andamento'
      expect(page).to have_content 'Lote ABC123456'
      expect(page).to have_content "Data de início: #{I18n.l lot.initial_date}"
      expect(page).to have_content "Data limite: #{I18n.l lot.limit_date}"
      expect(page).to have_content 'Lance mínimo: R$ 25,00'
      expect(page).to have_content 'Diferença mínima entre lances: R$ 5,00'
    end
  end

  it 'futuros' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    publisher = Admin.create!(email: 'jorge@leilaodogalpao.com.br', cpf: '38027134005', password:'password')

    lot = Lot.create!(code:'ABC123456', initial_date: (Date.today + 5.days), limit_date: (Date.today + 15.days),
                      minimum_bid: 25, minimum_bid_increment: 5,
                      status: :published, creator: creator, publisher: publisher)

    visit root_path

    within 'section#future-lots' do
      expect(page).to have_content 'Lotes Futuros'
      expect(page).to have_content 'Lote ABC123456'
      expect(page).to have_content "Data de início: #{I18n.l lot.initial_date}"
      expect(page).to have_content "Data limite: #{I18n.l lot.limit_date}"
      expect(page).to have_content 'Lance mínimo: R$ 25,00'
      expect(page).to have_content 'Diferença mínima entre lances: R$ 5,00'
    end
  end

  it 'mas não há registros publicados' do
    creator = Admin.create!(email: 'fulano@leilaodogalpao.com.br', cpf: '29973194047', password: 'password')
    lot = Lot.create!(code:'ABC123456', initial_date: (Date.today + 5.days), limit_date: (Date.today + 15.days),
                      minimum_bid: 25, minimum_bid_increment: 5, creator: creator)

    visit root_path

    within 'section#ongoing-lots' do
      expect(page).to have_content 'Não há lotes em andamento'
    end

    within 'section#future-lots' do
      expect(page).to have_content 'Não há lotes futuros'
    end
  end
end
