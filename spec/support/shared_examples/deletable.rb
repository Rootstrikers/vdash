shared_examples "it is deletable" do
  let!(:thing) { instance_of_described_class }

  describe 'default scope' do
    it 'excludes things marked as deleted' do
      deleted_thing = instance_of_described_class.update_attribute(:deleted_at, Time.now)
      described_class.all.should == [thing]
    end
  end

  describe '#delete' do
    it 'does not delete the thing' do
      thing.delete
      expect {
        thing.reload
      }.not_to raise_error
    end

    it 'sets deleted_at' do
      Timecop.freeze(Time.now) do
        thing.delete
        thing.reload.deleted_at.should == Time.now
      end
    end
  end
end