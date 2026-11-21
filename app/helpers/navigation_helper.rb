# frozen_string_literal: true

module NavigationHelper
  def sidebar_link(label, path)
    active = current_page?(path) ? 'bg-slate-800 text-white' : 'text-slate-300 hover:bg-slate-800 hover:text-white'
    tag.li(link_to(label, path, class: "block rounded-lg px-3 py-2 #{active}"))
  end
end
