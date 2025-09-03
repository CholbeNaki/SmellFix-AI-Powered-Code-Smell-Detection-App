function detectLongMethodsPython(code, maxLines = 20) {
  const lines = code.split('\n');
  const issues = [];
  let inFunc = false;
  let funcStart = 0;
  let funcName = "";

  lines.forEach((line, i) => {
    const trimmed = line.trim();
    if (trimmed.startsWith("def ")) {
      if (inFunc) {
        const length = i - funcStart;
        if (length > maxLines) {
          issues.push({
            type: "Long Method",
            message: `Function ${funcName} is too long (${length} lines).`,
            line: funcStart + 1,
            suggestion: "Split this function into smaller functions."
          });
        }
      }
      inFunc = true;
      funcStart = i;
      funcName = trimmed.split('(')[0].replace("def", "").trim();
    }
  });


  if (inFunc) {
    const length = lines.length - funcStart;
    if (length > maxLines) {
      issues.push({
        type: "Long Method",
        message: `Function ${funcName} is too long (${length} lines).`,
        line: funcStart + 1,
        suggestion: "Split this function into smaller functions."
      });
    }
  }

  return issues;
}

function detectLargeClassesJava(code, maxMethods = 10) {
  const lines = code.split('\n');
  const issues = [];
  let className = "";
  let methodCount = 0;

  lines.forEach((line) => {
    if (line.includes("class ")) {
      className = line.split("class ")[1].split(" ")[0];
      methodCount = 0;
    }
    if (line.match(/\w+\s+\w+\s*\(.*\)\s*{/)) {
      methodCount++;
    }
  });

  if (methodCount > maxMethods) {
    issues.push({
      type: "Large Class",
      message: `Class ${className} has ${methodCount} methods.`,
      suggestion: "Break the class into smaller, focused classes."
    });
  }

  return issues;
}

function detectUnusedImports(code, extension) {
  const lines = code.split('\n');
  const issues = [];

  if (extension === ".py") {
    lines.forEach((line, i) => {
      if (line.startsWith("import ") || line.startsWith("from ")) {
        issues.push({
          type: "Unused Import",
          message: `Possible unused import: "${line.trim()}"`,
          line: i + 1,
          suggestion: "Remove unused imports if not required."
        });
      }
    });
  } else if (extension === ".java") {
    lines.forEach((line, i) => {
      if (line.startsWith("import ")) {
        issues.push({
          type: "Unused Import",
          message: `Possible unused import: "${line.trim()}"`,
          line: i + 1,
          suggestion: "Remove unused imports if not required."
        });
      }
    });
  }

  return issues;
}

function detectDuplicateCode(code, minOccurrences = 2) {
  const lines = code.split('\n').map(l => l.trim()).filter(l => l.length > 0);
  const lineMap = {};
  const issues = [];

  lines.forEach((line, i) => {
    if (!lineMap[line]) {
      lineMap[line] = [];
    }
    lineMap[line].push(i + 1);
  });

  Object.entries(lineMap).forEach(([line, occurrences]) => {
    if (occurrences.length >= minOccurrences) {
      issues.push({
        type: "Duplicate Code",
        message: `Line "${line}" appears ${occurrences.length} times.`,
        line: occurrences[0],
        suggestion: "Consider refactoring to avoid duplicate code."
      });
    }
  });

  return issues;
}


function detectDeepNesting(code, maxDepth = 3) {
  const lines = code.split('\n');
  let currentDepth = 0;
  let maxSeen = 0;
  const issues = [];

  lines.forEach((line, i) => {
    const trimmed = line.trim();
    if (trimmed.endsWith("{") || trimmed.endsWith(":")) {
      currentDepth++;
      if (currentDepth > maxDepth) {
        issues.push({
          type: "Deep Nesting",
          message: `Deep nesting detected at line ${i + 1}. Current depth: ${currentDepth}`,
          line: i + 1,
          suggestion: "Refactor nested logic into helper functions."
        });
      }
      maxSeen = Math.max(maxSeen, currentDepth);
    }
    if (trimmed.endsWith("}") || trimmed === "") {
      if (currentDepth > 0) currentDepth--;
    }
  });

  return issues;
}

function analyzeFile(fileContent, extension) {
  let issues = [];

  if (extension === ".py") {
    issues = [
      ...detectLongMethodsPython(fileContent),
      ...detectUnusedImports(fileContent, extension),
      ...detectDuplicateCode(fileContent),
      ...detectDeepNesting(fileContent),
    ];
  } else if (extension === ".java") {
    issues = [
      ...detectLargeClassesJava(fileContent),
      ...detectUnusedImports(fileContent, extension),
      ...detectDuplicateCode(fileContent),
      ...detectDeepNesting(fileContent),
    ];
  }

  return issues;
}

module.exports = { analyzeFile };
