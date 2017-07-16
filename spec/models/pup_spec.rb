require 'spec_helper'

describe Pup do
  before :each do
    breed_1 = FactoryGirl.create(:breed, :name => 'Affenpinscher')
    breed_2 = FactoryGirl.create(:breed, :name => 'Afghan Hound')
    @affenpinscher_id = breed_1.id
    @afghan_hound_id = breed_2.id
    
    @dog_1 = FactoryGirl.create(:pup, :breed_id => @afghan_hound_id, :trainability => 3)
    @dog_2 = FactoryGirl.create(:pup, :breed_id => @affenpinscher_id)
    @dog_3 = FactoryGirl.create(:pup, :breed_id => @afghan_hound_id, :overall_health => 4)
    @dog_4 = FactoryGirl.create(:pup, :breed_id => @afghan_hound_id)
    @dog_5 = FactoryGirl.create(:pup, :breed_id => @affenpinscher_id)
  end
  
  describe 'should search dogs by single brred' do
    it "should return array of pup by correct breed" do
      result = Pup.find_by_breed("Affenpinscher")
      expect(result).to include(@dog_2, @dog_5)
      expect(result).not_to include(@dog_1, @dog_3, @dog_4)
    end
    
    it "should return an empty array for not existing breed" do
      result = Pup.find_by_breed("random breed")
      expect(result).to be_empty
    end
  end
  
  describe "should search a dog by breeds" do
    it "should find all dogs with a single breed and no second breed" do
      results = Pup.find_by_breeds('Affenpinscher')
      assert(results.member?(@dog_2))
      assert(results.member?(@dog_5))
      assert(!results.member?(@dog_1))
      assert(!results.member?(@dog_4))
      assert(!results.member?(@dog_3))
    end
    it "should find all dogs with both breeds and not with only 1 of the breeds" do
      results = Pup.find_by_breeds('Affenpinscher', 'Afghan Hound')
      assert(results.member? @dog_1)
      assert(results.member? @dog_3)
      assert(results.member?(@dog_4))
      assert(!results.member?(@dog_2))
      assert(!results.member?(@dog_5))
    end
    it "should return empty array if enter invaid breed" do
      result1 = Pup.find_by_breeds("fake breed")
      result2 = Pup.find_by_breeds("random breed", "Affenpinscher")
      expect(result1).to be_empty
      expect(result2).to be_empty
    end
  end
  describe "should find the average ratings for a dog breed" do
    it "should find the average ratings is 0 if there are no matching breeds in db" do
      ratings_hash = Pup.avg_ratings_by_breeds('Affenpinscher')
      ratings_hash.each do |rating, value|
        assert(value == 1)
      end
    end
    it "should find the correct average ratings for a single breed dog" do
      ratings_hash = Pup.avg_ratings_by_breeds('Afghan Hound')
      correct_hash = {:overall_health => 2, :trainability => 5.0/3.0, :social_behavior => 1,
                      :dog_behavior => 1, :energy_level => 1, :simpatico_rating => 1}
                      
      assert(correct_hash == ratings_hash)
    end
    # it "should find the average ratings for a mixed breed dog" do
    #   dog_1 = FactoryGirl.create(:pup, :breed_2 => 'poodle')
    #   dog_2 = FactoryGirl.create(:pup)
    #   dog_3 = FactoryGirl.create(:pup, :breed_2 => 'poodle')
    #   dog_4 = FactoryGirl.create(:pup, :breed_2 => 'German Short Hair')
    #   dog_5 = FactoryGirl.create(:pup)
      
    #   ratings_hash = Pup.avg_ratings_by_breeds('poodle', 'shiba inu')
      
    #   ratings_hash.each do |rating, value|
    #     assert(value == 1)
    #   end

    # end
  end
  describe "returning a safe hashtag no matter what the values of hashtags_1-3 are" do
    it "should return a default string if no hashtags" do
      pup = FactoryGirl.create(:pup)
      pup.safe_hashtag_string.should == []
    end
    it "should return the joined hashtags that are present" do
      pup = FactoryGirl.create(:pup, :hashtag_1 => "#lolright", :hashtag_2 => "#okilydokily")
      pup.safe_hashtag_string.should == ['#lolright', '#okilydokily']
    end
    it "should return all three joined hashtags" do
      pup = FactoryGirl.create(:pup, :hashtag_1 => "#lolright", :hashtag_2 => "#okilydokily", :hashtag_3 => "#i'mdone")
      pup.safe_hashtag_string.should == ['#lolright', '#okilydokily', '#i\'mdone']
    end
  end
  describe "check whether a breed is legal one" do
    it "should return true on legal breed type" do
      Pup.legal_dog("Affenpinscher").should be_true
    end
    it "should return false on illegal breed type" do
      Pup.legal_dog("make_up_breed").should be_false
    end
  end
end