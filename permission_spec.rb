require 'rails_helper'

RSpec.describe Permission, type: :model do
  let(:page) { Permission.new(nil) }
  
  describe 'allows access' do
    it { expect(page.allow?('sessions', nil, nil)).to be_truthy }
    it { expect(page.allow?('pages', 'landing', nil)).to be_truthy }
    it { expect(page.allow?('pages', 'about', nil)).to be_truthy }
    it { expect(page.allow?('pages', 'dashboard', nil)).to be_falsy }
    it { expect(page.allow?('users', 'index', nil)).to be_truthy }
    it { expect(page.allow?('users', 'show', nil)).to be_truthy }
    it { expect(page.allow?('users', 'create', nil)).to be_falsy }
  end
  
  describe 'as a logged in user' do
    let(:user) { User.new(email: 'test@example.com', password: 'password') }
    let(:list) { user.lists.build(id: 1) }
    let(:page) { Permission.new(user) }
    
    context 'allows' do
      
      it { expect(page.allow?('staff', 'index', nil)).to be_truthy }
      it { expect(page.allow?('notifications', 'index', nil)).to be_truthy }
      it { expect(page.allow?('notifications', 'show', nil)).to be_truthy }
      
      context 'users_controller update' do
        before do
          allow(User).to receive(:find).with(1).and_return(user)
        end
        
        it { expect(page.allow?('users', 'update', { id: 1 })).to be_truthy }
      end
      
      context 'admin' do
        before do
          user.admin = true
        end
        
        it { expect(page.allow?('pages', 'dashboard', nil)).to be_truthy }
        it { expect(page.allow?('lists', 'index', nil)).to be_truthy }
        it { expect(page.allow?('lists', 'create', nil)).to be_truthy }
        it { expect(page.allow?('lists', 'show', nil)).to be_truthy }
        
        context 'lists_controller' do
          before do
            user.admin = true
            allow(List).to receive(:find).and_return(nil)
            allow(List).to receive(:find).with(1).and_return(list)
          end
          
          it { expect(page.allow?('lists', 'create', nil)).to be_truthy }
          it { expect(page.allow?('lists', 'update', { id: 1 })).to be_truthy }
          it { expect(page.allow?('lists', 'update', { id: 2 })).to be_falsy }
        end
      end
      
      context 'super admin' do
        before do
          user.super_admin = true
        end
        
        it { expect(page.allow?('pages', 'dashboard', nil)).to be_truthy }
        it { expect(page.allow?('lists', 'create', nil)).to be_truthy }
        it { expect(page.allow?('lists', 'update', nil)).to be_truthy }
      end
    
    end
  end
end