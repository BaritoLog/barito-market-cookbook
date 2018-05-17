class Chef::Recipe::HostProperties
  def self.available_memory(memory)
    0.95 * memory[/\d*/].to_i
  end

  def self.max_working_memory(memory)
    0.25 * available_memory(memory).floor
  end
end
