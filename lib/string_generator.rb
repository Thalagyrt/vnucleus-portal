class StringGenerator
  REFERENCE = {
      chars: (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a) - %w{I l 1 O 0},
      length: 14
  }
  PASSWORD = {
      chars: (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a) - %w{I l 1 O 0},
      length: 16
  }
  USERNAME = {
      chars: (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a) - %w{I l 1 O 0},
      length: 24
  }
  LONG_ID = {
      chars: (('a'..'z').to_a + ('0'..'9').to_a) - %w{I l 1 O 0},
      length: 5
  }
  BANNED = []

  class << self
    def reference
      new(REFERENCE).next
    end

    def password
      new(PASSWORD).next
    end

    def username
      new(USERNAME).next
    end

    def long_id
      new(LONG_ID).next
    end
  end

  def initialize(opts = {})
    @chars = opts[:chars] || PASSWORD_CHARS
    @length = opts[:length] || PASSWORD_LENGTH
  end

  def next
    loop do
      string = generate
      BANNED.each do |banned|
        if string.match(banned)
          string = nil
          break
        end
      end
      return string if string.present?
    end
  end

  private
  attr_accessor :chars, :length

  def generate
    (1..length).map { chars.sample(random: SecureRandom) }.join
  end
end
