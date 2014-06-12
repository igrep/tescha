module Tescha
  @ready = false
end
class << Tescha
  def get_ready!
    @ready = true
  end
  def ready?
    @ready
  end
end
