import AST


def printBranch(branch, height):
    print height * "| " + str(branch)


def addToClass(cls):
    def decorator(func):
        setattr(cls, func.__name__, func)
        return func

    return decorator


class TreePrinter:
    @addToClass(AST.Node)
    def printTree(self, height=0):
        raise Exception("printTree not defined in class " + self.__class__.__name__)

    @addToClass(AST.Program)
    def printTree(self):
        self.declarations.printTree()
        self.fundefs.printTree()
        self.instructions.printTree()

    @addToClass(AST.Declarations)
    def printTree(self, height=0):
        printBranch(self.attr(), height)
        map(lambda declaration: declaration.printTree(height + 1), self.declarations)

    @addToClass(AST.Declaration)
    def printTree(self, height=0):
        self.inits.printTree(height)

    @addToClass(AST.Inits)
    def printTree(self, height=0):
        map(lambda init: init.printTree(height), self.inits)

    @addToClass(AST.Init)
    def printTree(self, height=0):
        printBranch(self.attr(), height)
        printBranch(self.ID, height + 1)
        self.expression.printTree(height + 1)

    @addToClass(AST.Instructions)
    def printTree(self, height=0):
        map(lambda instruction: instruction.printTree(height), self.instructions)

    @addToClass(AST.Print_instr)
    def printTree(self, height=0):
        printBranch(self.attr(), height)
        self.expression.printTree(height + 1)

    @addToClass(AST.Labeled_instr)
    def printTree(self, height=0):
        printBranch(self.ID, height)
        self.instruction.printTree(height + 1)

    @addToClass(AST.Assignment)
    def printTree(self, height=0):
        printBranch(self.attr(), height)
        printBranch(self.ID, height + 1)
        self.expression.printTree(height + 1)

    @addToClass(AST.Choice_instr)
    def printTree(self, height=0):
        printBranch(self.attrIF(), height)
        self.condition.printTree(height + 1)
        self.instruction1.printTree(height + 1)
        if self.instruction2:
            printBranch(self.attrELSE(), height)
            self.instruction2.printTree(height + 1)

    @addToClass(AST.While_instr)
    def printTree(self, height=0):
        printBranch(self.attr(), height)
        self.condition.printTree(height + 1)
        self.instruction.printTree(height + 1)

    @addToClass(AST.Repeat_instr)
    def printTree(self, height=0):
        printBranch(self.attrREPEAT(), height)
        self.condition.printTree(height + 1)
        printBranch(self.attrUNTIL(), height)
        self.instruction.printTree(height + 1)

    @addToClass(AST.Return_instr)
    def printTree(self, height=0):
        printBranch(self.attr(), height)
        self.expression.printTree(height + 1)

    @addToClass(AST.Continue_instr)
    def printTree(self, height=0):
        printBranch(self.attr(), height)

    @addToClass(AST.Break_instr)
    def printTree(self, height=0):
        printBranch(self.attr(), height)

    @addToClass(AST.Compound_instr)
    def printTree(self, height=0):
        if self.declarations:
            self.declarations.printTree(height)
        self.instructions.printTree(height)

    @addToClass(AST.Condition)
    def printTree(self, height=0):
        self.expression.printTree(height)

    @addToClass(AST.Const)
    def printTree(self, height=0):
        printBranch(self.value, height)

    @addToClass(AST.ID)
    def printTree(self, height=0):
        printBranch(self.value, height)

    @addToClass(AST.BinaryExpression)
    def printTree(self, height=0):
        printBranch(self.operator, height)
        self.leftExpression.printTree(height + 1)
        self.rightExpression.printTree(height + 1)

    @addToClass(AST.Expr_list)
    def printTree(self, height=0):
        map(lambda expression: expression.printTree(height), self.expr_list)

    @addToClass(AST.CallFunction)
    def printTree(self, height=0):
        printBranch(self.attr(), height)
        printBranch(self.ID, height + 1)
        self.expr_list_or_empty.printTree(height + 1)

    @addToClass(AST.Fundefs)
    def printTree(self, height=0):
        map(lambda fundef: fundef.printTree(height), self.fundefs)

    @addToClass(AST.Fundef)
    def printTree(self, height=0):
        printBranch(self.attrFUNDEF(), height)
        printBranch(self.ID, height + 1)
        if self.TYPE:
            printBranch(self.attrRET() + self.TYPE, height + 1)
        if self.args_list_or_empty:
            self.args_list_or_empty.printTree(height + 1)
        self.compound_instr.printTree(height + 1)

    @addToClass(AST.Args_list)
    def printTree(self, height=0):
        map(lambda arg: arg.printTree(height), self.args_list)

    @addToClass(AST.Arg)
    def printTree(self, height=0):
        printBranch(self.attr() + self.ID, height)

