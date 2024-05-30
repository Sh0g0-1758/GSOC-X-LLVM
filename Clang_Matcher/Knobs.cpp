#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"

using namespace clang::tooling;
using namespace llvm;
using namespace clang;
using namespace clang::ast_matchers;

static cl::OptionCategory MyToolCategory("my-tool options");

static cl::extrahelp CommonHelp(CommonOptionsParser::HelpMessage);
static cl::extrahelp MoreHelp("\nMore help text...\n");

DeclarationMatcher GlobalConstKnobMatcher =
  varDecl(
    hasType(isConstQualified()),
    hasGlobalStorage(),
    hasInitializer(
      ignoringImpCasts(
        integerLiteral()
      )
    )
  ).bind("knobVar");

DeclarationMatcher ConstructorWithFunctionInitMatcher = 
  varDecl(
      has(exprWithCleanups(
          has(cxxConstructExpr(
              has(materializeTemporaryExpr(
                  has(implicitCastExpr(
                      has(callExpr(
                          callee(functionDecl(
                              hasName("init"),
                              hasDeclContext(namespaceDecl(hasName("cl")))
                          ))
                      ))
                  ))
              ))
          ))
      ))
  ).bind("knobVar");

class KnobPrinter : public MatchFinder::MatchCallback {
public:
  virtual void run(const MatchFinder::MatchResult &Result) {
    ASTContext *Context = Result.Context;
    const VarDecl *KV = Result.Nodes.getNodeAs<VarDecl>("knobVar");
    if (!KV ||
        !Context->getSourceManager().isWrittenInMainFile(KV->getLocation()))
      return;
    outs() << "Potential knob discovered at "
           << KV->getLocation().printToString(Context->getSourceManager())
           << "\n";
    outs() << "Name: " << KV->getNameAsString() << "\n";
    outs() << "Type: " << KV->getType().getAsString() << "\n";
  }
};

int main(int argc, const char **argv) {
  auto ExpectedParser = CommonOptionsParser::create(argc, argv, MyToolCategory);
  if (!ExpectedParser) {
    errs() << ExpectedParser.takeError();
    return 1;
  }
  CommonOptionsParser &OptionsParser = ExpectedParser.get();
  ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());

  KnobPrinter Printer;
  MatchFinder Finder;
  Finder.addMatcher(GlobalConstKnobMatcher, &Printer);
  Finder.addMatcher(ConstructorWithFunctionInitMatcher, &Printer);

  return Tool.run(newFrontendActionFactory(&Finder).get());
}
