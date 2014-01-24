class Node(object):
    def accept(self, visitor):
        return visitor.visit(self)

    def __init__(self):
        self.children = ()


class Program(object):
    def __init__(self, declarations, fundefs, instructions):
        self.declarations = declarations
        self.fundefs = fundefs
        self.instructions = instructions
        self.children = (declarations, fundefs, instructions)
        return self.printTree()


class Declarations(Program):
    def __init__(self, declaration, declarations=None):
        if declarations:
            self.declarations = declarations
            self.declarations.append(declaration)
        else:
            self.declarations = [declaration]

    def attr(self):
        return "DECL"


class Declaration(Program):
    def __init__(self, TYPE, inits):
        self.TYPE = TYPE
        self.inits = inits


class Inits(Program):
    def __init__(self, init, inits=None):
        if inits:
            self.inits = inits
            self.inits.append(init)
        else:
            self.inits = [init]


class Init(Program):
    def __init__(self, ID, expression):
        self.ID = ID
        self.expression = expression

    def attr(self):
        return "="


class Expression(Program):
    def __init__(self):
        pass


class Instructions(Program):
    def __init__(self, instruction, instructions=None):
        if instructions:
            self.instructions = instructions
            self.instructions.append(instruction)
        else:
            self.instructions = [instruction]


class Instruction(Program):
    def __init__(self):
        pass


class Print_instr(Instruction):
    def __init__(self, expression):
        self.expression = expression

    def attr(self):
        return "PRINT"


class Labeled_instr(Instruction):
    def __init__(self, ID, instruction):
        self.ID = ID
        self.instruction = instruction


class Assignment(Instruction):
    def __init__(self, ID, expression):
        self.ID = ID
        self.expression = expression

    def attr(self):
        return "="


class Choice_instr(Instruction):
    def __init__(self, condition, instruction1, instruction2=None):
        self.condition = condition
        self.instruction1 = instruction1
        self.instruction2 = instruction2

    def attrIF(self):
        return "IF"

    def attrELSE(self):
        return "ELSE"


class While_instr(Instruction):
    def __init__(self, condition, instruction):
        self.condition = condition
        self.instruction = instruction

    def attr(self):
        return "WHILE"


class Repeat_instr(Instruction):
    def __init__(self, condition, instruction):
        self.condition = condition
        self.instruction = instruction

    def attrREPEAT(self):
        return "REPEAT"

    def attrUNTIL(self):
        return "UNTIL"


class Return_instr(Instruction):
    def __init__(self, expression):
        self.expression = expression

    def attr(self):
        return "RETURN"


class Continue_instr(Instruction):
    def __init__(self):
        pass

    def attr(self):
        return "CONTINUE"


class Break_instr(Instruction):
    def __init__(self):
        pass

    def attr(self):
        return "BREAK"


class Compound_instr(Instruction):
    def __init__(self, declarations, instructions):
        self.declarations = declarations
        self.instructions = instructions


class Condition(Program):
    def __init__(self, expression):
        self.expression = expression


class Const(Program):
    def __init__(self, value):
        self.value = value

    def type(self):
        if type(self.value) == int:
            return " (integer) "
        if type(self.value) == str:
            return " (string) "
        if type(self.value) == float:
            return " (float) "


class ID(Expression):
    def __init__(self, value):
        self.value = value


class BinaryExpression(Expression):
    def __init__(self, leftExpression, operator, rightExpression):
        self.leftExpression = leftExpression
        self.rightExpression = rightExpression
        self.operator = operator
        self.children = (leftExpression, rightExpression)


class CallFunction(Expression):
    def __init__(self, ID, expr_list_or_empty):
        self.ID = ID
        self.expr_list_or_empty = expr_list_or_empty

    def attr(self):
        return "FUNCALL"


class Expr_list(Program):
    def __init__(self, expression, expr_list=None):
        if expr_list:
            self.expr_list = expr_list
            self.expr_list.append(expression)
        else:
            self.expr_list = [expression]


class Fundefs(Program):
    def __init__(self, fundef, fundefs=None):
        if fundefs:
            self.fundefs = [fundef]
            self.fundefs.extend(fundefs)
        else:
            self.fundefs = [fundef]


class Fundef(Program):
    def __init__(self, TYPE, ID, args_list_or_empty, compound_instr):
        self.TYPE = TYPE
        self.ID = ID
        self.args_list_or_empty = args_list_or_empty
        self.compound_instr = compound_instr

    def attrFUNDEF(self):
        return "FUNDEF"

    def attrRET(self):
        return "RET "


class Args_list(Program):
    def __init__(self, arg, args_list=None):
        if args_list:
            self.args_list = args_list
            self.args_list.append(arg)
        else:
            self.args_list = [arg]


class Arg(Program):
    def __init__(self, TYPE, ID):
        self.TYPE = TYPE
        self.ID = ID

    def attr(self):
        return "ARG "
