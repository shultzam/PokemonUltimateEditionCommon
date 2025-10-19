-- Ensure tokens are always random.
function onCollisionExit(object)
  self.shuffle()
end