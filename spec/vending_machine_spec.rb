require './vending_machine'

describe 'vending_machineテスト' do
  let!(:vm) { VendingMachine.new }
  describe "インスタンス作成のテスト" do
    context "VendingMachineをインスタンス化させた際" do
      it "@salesに0が代入されている" do
        expect(vm.sales).to eq(0)
      end

      it "@balanceに0が代入されている" do
        expect(vm.balance).to eq(0)
      end

      it "Stockクラスがインスタンス化され、@productsに既定の配列が格納されている" do
        expect(vm.stock.products).to eq([{name: 'コーラ', price: 120, stock: 5}])
      end
    end
  end
  describe "お金関連の処理のテスト" do
    before do
      vm.receive_money(500)
    end
    context "お金を投入した場合" do
      it "@balanceに投入した金額が追加される" do
        expect(vm.balance).to eq(500)
      end
    end

    context "想定外の通貨が投入された場合" do
      before do
        vm.receive_money(700)
      end
      it "@balanceの値は変わらない" do
        expect(vm.balance).to eq(500)
      end
    end
    context "返金した場合" do
      before do
        vm.return_change
      end
      it "@balanceの値が0になる" do
        expect(vm.balance).to eq(0)
      end
    end
  end
  describe "購入関連のテスト" do
    context "購入可能な場合" do
    end
  end
end
