-- evaluator.lua
-- Glenn G. Chappell
-- Started: 2025-04-03
-- Updated: 2025-04-04
--
-- For CS 331 Spring 2025
-- Evaluator for Arithmetic Expression AST (rdparser3.lua format)
-- See calculator.lua for a sample main program.


local evaluator = {}  -- Our module


-- Symbolic Constants for AST

local BIN_OP     = 1
local NUMLIT_VAL = 2
local SIMPLE_VAR = 3


-- Primary Function

-- evaluator.eval
-- Takes AST for an expression, in format specified in rdparser3.lua,
-- and table holding values of variables. Returns numeric value of
-- expression.
--
-- Example of a simple tree-walk interpreter.
function evaluator.eval(ast, vars)
    local result, literal, varname, op, arg1_ast, arg2_ast,
          arg1_val, arg2_val

    assert(type(ast) == "table")
    assert(type(vars) == "table")

    assert(#ast >= 1)
    if ast[1] == NUMLIT_VAL then        -- Numeric literal
        assert(#ast == 2)
        literal = ast[2]
        assert(type(literal) == "string")
        result = tonumber(literal)
        assert(type(result) == "number")

    elseif ast[1] == SIMPLE_VAR then    -- Simple variable
        assert(#ast == 2)
        varname = ast[2]
        assert(type(varname) == "string")
        result = vars[varname]
        if result == nil then  -- Undefined variable
            result = 0
        end
        assert(type(result) == "number")

    elseif type(ast[1] == "table") then  -- Operator
        assert(#ast == 3)
        assert(#ast[1] == 2)
        assert(ast[1][1] == BIN_OP)

        op = ast[1][2]
        assert(type(op) == "string")

        arg1_ast = ast[2]
        assert(type(arg1_ast) == "table")
        arg1_val = evaluator.eval(arg1_ast, vars)
        assert(type(arg1_val) == "number")

        arg2_ast = ast[3]
        assert(type(arg2_ast) == "table")
        arg2_val = evaluator.eval(arg2_ast, vars)
        assert(type(arg2_val) == "number")

        if op == "+" then
            result = arg1_val + arg2_val
        elseif op == "-" then
            result = arg1_val - arg2_val
        elseif op == "*" then
            result = arg1_val * arg2_val
        elseif op == "/" then
            result = arg1_val / arg2_val  -- Let Lua floating-point
                                          --  handle div by zero, etc.
        else
            assert(false, "AST is not in proper format")
        end
        assert(type(result) == "number")

    else
        assert(false, "AST is not in proper format")
    end

    return result
end


-- Module Export

return evaluator

