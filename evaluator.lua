-- evaluator.lua  UNFINISHED
-- Glenn G. Chappell
-- 2025-04-03
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
    -- TODO: WRITE THIS!!!
    return 42  -- DUMMY
end


-- Module Export

return evaluator

