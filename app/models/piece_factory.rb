class PieceFactory
  def self.get_instance_of(type) 
    return Pawn.new if type == 5 or type == 11 
  end
end