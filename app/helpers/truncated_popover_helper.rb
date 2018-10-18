module TruncatedPopoverHelper
  def truncate_popover(string)
    content_tag(:a, class: 'cursor-pointer', data: { toggle: 'popover', placement: 'bottom', content: string }) do
      truncate(string)
    end
  end
end