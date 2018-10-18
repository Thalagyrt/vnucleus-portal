module SimpleDatatable
  extend ActiveSupport::Concern

  included do
    delegate :params, :truncate_popover, :link_to, :number_to_currency, to: :view

    def self.sort_columns(sort_columns = nil)
      if sort_columns.present?
        @sort_columns = sort_columns
      end

      @sort_columns
    end

    private
    attr_reader :objects_scope
    attr_reader :view
  end

  def initialize(objects_scope, view)
    @objects_scope = objects_scope
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: objects_scope.count,
        iTotalDisplayRecords: objects.total_count,
        aaData: data
    }
  end

  def data
    objects.map(&:decorate).map do |object|
      render(object)
    end
  end

  def objects
    @objects ||= load_objects
  end

  def prefilter_objects(objects)
    objects
  end

  private
  def load_objects
    objects = prefilter_objects(objects_scope)
    objects = objects.order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      objects = objects.search(params[:sSearch])
    end
    objects = objects.page(page).per(per)
    objects
  end

  def page
    params[:iDisplayStart].to_i/per + 1
  end

  def per
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    self.class.sort_columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end