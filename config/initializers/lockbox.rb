# frozen_string_literal: true

def lockbox_key
  return ENV['LOCKBOX_MASTER_KEY'] if Rails.env.production?

  'd118c586cf490d219702908bab9d4361e5df995bab99201c753cc4d72ad5622f'
end

Lockbox.master_key = lockbox_key
