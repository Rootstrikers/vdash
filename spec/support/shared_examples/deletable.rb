shared_examples "it is deletable" do
  let!(:thing) { instance_of_described_class }

  describe 'default scope' do
    it 'excludes things marked as deleted' do
      deleted_thing = instance_of_described_class
      deleted_thing.update_attribute(:deleted_at, Time.now)

      described_class.all.should == [thing]
    end
  end

  describe '.deleted' do
    it 'returns things marked as deleted' do
      deleted_thing = instance_of_described_class
      deleted_thing.update_attribute(:deleted_at, Time.now)

      described_class.deleted.should == [deleted_thing]
    end

    it 'returns newly deleted things first' do
      deleted_thing_one = instance_of_described_class.tap { |thing| thing.update_attribute(:deleted_at, 2.days.ago) }
      deleted_thing_two = instance_of_described_class.tap { |thing| thing.update_attribute(:deleted_at, 1.days.ago) }

      described_class.deleted.should == [deleted_thing_two, deleted_thing_one]
    end
  end

  describe '#fake_delete' do
    it 'does not delete the thing' do
      thing.fake_delete
      expect {
        thing.reload
      }.not_to raise_error
    end

    it 'sets deleted_at' do
      Timecop.freeze(Time.now) do
        thing.fake_delete
        thing.reload.deleted_at.should == Time.now
      end
    end
  end
end