module Blog
  class Post < ActiveRecord::Base
    extend Enumerize
    include PgSearch

    acts_as_taggable

    belongs_to :user, class_name: ::Users::User

    validates :title, presence: true
    validates :body, presence: true
    validates :summary, presence: true

    before_save :set_published_at

    enumerize :status, in: { draft: 1, published: 2 }, default: :draft, scope: true, predicates: true

    scope :sorted, -> { order('published_at DESC') }

    scope :published, -> { with_status(:published) }

    pg_search_scope :search,
                    against: { body: 'A', title: 'A' },
                    associated_against: {
                        tags: { name: 'B' },
                        user: { first_name: 'B', last_name: 'B' }
                    },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }

    def to_s
      title
    end

    def to_param
      [id, title.parameterize].join('-')
    end

    private
    def set_published_at
      if published?
        self.published_at ||= Time.zone.now
      end
    end
  end
end