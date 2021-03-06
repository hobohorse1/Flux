-- Sorta model-view-controller implementation, except the model isn't /actually/ used lol.

library 'MVC'

if CLIENT then
  local mvc_hooks = {}

  function MVC.push(name, ...)
    if !isstring(name) then return end

    Cable.send('fl_mvc_push', name, ...)
  end

  function MVC.pull(name, handler, prevent_remove)
    if !isstring(name) or !isfunction(handler) then return end

    mvc_hooks[name] = mvc_hooks[name] or {}

    table.insert(mvc_hooks[name], {
      handler = handler,
      prevent_remove = prevent_remove
    })
  end

  function MVC.request(name, handler, ...)
    MVC.pull(name, handler)
    MVC.push(name, ...)
  end

  function MVC.listen(name, handler)
    MVC.pull(name, handler, true)
  end

  Cable.receive('fl_mvc_pull', function(name, ...)
    local hooks = mvc_hooks[name]

    if hooks then
      for k, v in ipairs(hooks) do
        local success, value = pcall(v.handler, ...)

        if !success then
          ErrorNoHalt("The '"..name.." - "..tostring(k).."' MVC callback has failed to run!\n")
          ErrorNoHalt(tostring(value)..'\n')
        end

        if !v.prevent_remove then
          table.remove(mvc_hooks[name], k)
        end
      end
    end
  end)
else
  local mvc_handlers = {}

  function MVC.handler(name, handler)
    if !isstring(name) then return end

    mvc_handlers[name] = mvc_handlers[name] or {}

    table.insert(mvc_handlers[name], handler)
  end

  function MVC.push(player, name, ...)
    if !isstring(name) then return end

    Cable.send(player, 'fl_mvc_pull', name, ...)
  end

  Cable.receive('fl_mvc_push', function(player, name, ...)
    local handlers = mvc_handlers[name]

    if handlers then
      for k, v in ipairs(handlers) do
        local success, value = pcall(v, player, ...)

        if !success then
          ErrorNoHalt("The '"..name.." - "..tostring(k).."' MVC handler has failed to run!\n")
          ErrorNoHalt(tostring(value)..'\n')
        end
      end
    end
  end)
end
