module DisplayHelper
  def display_for(model, &block)
    content_tag :div, class: 'table-responsive' do
      content_tag :table, class: 'table table-condensed table-definitions' do
        capture(DisplayBlock.new(model, self), &block)
      end
    end
  end

  class DisplayBlock
    attr_reader :model, :helper

    def initialize(model, helper)
      @model, @helper = model, helper
    end

    def display(field, opts = {}, &block)
      content = if block_given?
                  helper.capture(&block)
                else
                  model.public_send(field)
                end

      disp_label = opts.fetch(:label) { model.class.human_attribute_name(field.to_s.gsub(/^render_/, '')) }

      helper.content_tag(:tr, class: opts[:class]) do
        helper.concat helper.content_tag(:th, disp_label)
        helper.concat helper.content_tag(:td, content)
      end
    end
  end
end