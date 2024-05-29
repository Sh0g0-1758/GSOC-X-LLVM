#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"

using namespace clang::tooling;
using namespace llvm;
using namespace clang;
using namespace clang::ast_matchers;

static llvm::cl::OptionCategory MyToolCategory("my-tool options");

DeclarationMatcher KnobMatcher = declaratorDecl(hasTypeLoc(loc(asString("const int")))).bind("knobVar");

class KnobPrinter : public MatchFinder::MatchCallback {
public :
  virtual void run(const MatchFinder::MatchResult &Result) {
    ASTContext *Context = Result.Context;
    const VarDecl *FS = Result.Nodes.getNodeAs<VarDecl>("knobVar");
    // We do not want to convert header files!
    if (!FS || !Context->getSourceManager().isWrittenInMainFile(FS->getLocation()))
      return;
    llvm::outs() << "Potential knob discovered at " << FS->getLocation().printToString(Context->getSourceManager()) << "\n";
    llvm::outs() << "Name: " << FS->getNameAsString() << "\n";
    llvm::outs() << "Type: " << FS->getType().getAsString() << "\n";
    llvm::outs() << "QualType: " << FS->getType().getQualifiers().getAsString() << "\n";
  }
};

int main(int argc, const char **argv) {
  auto ExpectedParser = CommonOptionsParser::create(argc, argv, MyToolCategory);
  if (!ExpectedParser) {
    llvm::errs() << ExpectedParser.takeError();
    return 1;
  }
  CommonOptionsParser& OptionsParser = ExpectedParser.get();
  ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());

  KnobPrinter Printer;
  MatchFinder Finder;
  Finder.addMatcher(KnobMatcher, &Printer);

  return Tool.run(newFrontendActionFactory(&Finder).get());
}