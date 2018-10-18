class KnowledgeBase::Article < ActiveRecord::Base
  extend Enumerize
  include PgSearch

  acts_as_taggable

  validates :title, presence: true
  validates :body, presence: true
  validates :summary, presence: true

  enumerize :status, in: { draft: 1, published: 2 }, default: :draft, scope: true, predicates: true

  scope :published, -> { with_status(:published) }

  pg_search_scope :search,
                  against: { id: 'C', body: 'A', title: 'A' },
                  associated_against: {
                      tags: { name: 'B' }
                  },
                  using: {
                      tsearch: {
                          prefix: true,
                          dictionary: 'english'
                      }
                  }

  def to_s
    "KB##{id}: #{title}"
  end

  def to_param
    [id, title.parameterize].join('-')
  end
end