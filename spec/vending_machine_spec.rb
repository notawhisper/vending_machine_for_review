require './lib/vending_machine'

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
      it "Finderモジュールのfind_product_by_nameメソッドで@productsの既定の配列から商品情報を取り出すことができる" do
        expect(vm.stock.find_product_by_name("コーラ")).to eq({name: 'コーラ', price: 120, stock: 5})
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
  describe "ストック関連" do
    context "インスタンス化された場合" do
      it "既定の商品がストックに追加されている" do
        expect(vm.stock.find_product_by_name("コーラ")[:name]).to eq("コーラ")
      end
      it "@productsに新しい商品を追加できる" do
        vm.stock.add_new_product("レッドブル", 200, 5)
        expect(vm.stock.find_product_by_name("レッドブル")[:name]).to eq("レッドブル")
      end
      it "@productsの既存の商品からストックを減らすことができる" do
        vm.stock.remove("コーラ", 5)
        expect(vm.stock.find_product_by_name("コーラ")[:stock]).to eq(0)
      end
      it "@productsの既存の商品のストックを増やすことができる" do
        vm.stock.restock("コーラ", 5)
        expect(vm.stock.find_product_by_name("コーラ")[:stock]).to eq(10)
      end
    end
  end
  describe "購入関連のテスト" do
    before do
      vm.stock.add_new_product("水", 100, 0)
      vm.stock.add_new_product("カルピス", 150, 0)
      vm.stock.add_new_product("レッドブル", 200, 5)
      vm.receive_money(100)
      vm.receive_money(10)
      vm.receive_money(10)
      vm.receive_money(10)
    end
    context "残高も在庫もある場合" do
      it "購入可能と判定される" do
        expect(vm.available?("コーラ")).to eq(true)
      end
      it "商品を購入できる" do
        vm.dispense("コーラ")
        expect(vm.sales).to eq(120)
        expect(vm.balance).to eq(10)
        expect(vm.stock.find_product_by_name("コーラ")[:stock]).to eq(4)
      end
    end
    context "残高はあるが在庫がない場合" do
      it "購入可能と判定されない" do
        expect(vm.available?("水")).to eq(false)
      end
      it "商品を購入できない" do
        vm.dispense("水")
        expect(vm.sales).to eq(0)
        expect(vm.balance).to eq(130)
        expect(vm.stock.find_product_by_name("水")[:stock]).to eq(0)
      end
    end
    context "在庫もない、残高も足りない場合" do
      it "購入可能と判定されない" do
        expect(vm.available?("カルピス")).to eq(false)
      end
      it "商品を購入できない" do
        vm.dispense("カルピス")
        expect(vm.sales).to eq(0)
        expect(vm.balance).to eq(130)
        expect(vm.stock.find_product_by_name("カルピス")[:stock]).to eq(0)
      end
    end
    context "在庫はあるが残高が足りない場合" do
      it "購入可能と判定されない" do
        expect(vm.available?("レッドブル")).to eq(false)
      end
      it "商品を購入できない" do
        vm.dispense("レッドブル")
        expect(vm.sales).to eq(0)
        expect(vm.balance).to eq(130)
        expect(vm.stock.find_product_by_name("レッドブル")[:stock]).to eq(5)
      end
    end
    context "購入可能リストを表示する場合" do
      it "購入可能と判定された商品だけが表示される" do
        expect(vm.available_products).to eq([{name: 'コーラ', price: 120, stock: 5}])
      end
    end
  end
end
