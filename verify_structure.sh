#!/bin/bash

echo "Verifying Flutter GetX Architecture Structure..."
echo ""

echo "Checking directories..."
dirs=(
    "lib/base"
    "lib/data/auth"
    "lib/data/fax"
    "lib/data/sms"
    "lib/data/todos"
    "lib/data/voice"
    "lib/domain/auth"
    "lib/domain/fax"
    "lib/domain/sms"
    "lib/domain/todos"
    "lib/domain/voice"
    "lib/features/auth"
    "lib/features/fax"
    "lib/features/home"
    "lib/features/sms"
    "lib/features/todos"
    "lib/features/voice"
    "lib/services"
    "lib/theme"
    "lib/util"
)

for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ $dir"
    else
        echo "✗ $dir (missing)"
    fi
done

echo ""
echo "Checking key files..."
files=(
    "lib/main.dart"
    "lib/base/base_controller.dart"
    "lib/domain/auth/repositories/auth_repository.dart"
    "lib/domain/todos/repositories/todo_repository.dart"
    "lib/domain/auth/usecases/login_use_case.dart"
    "lib/domain/fax/usecases/fetch_fax_conversations_use_case.dart"
    "lib/domain/sms/usecases/fetch_sms_conversations_use_case.dart"
    "lib/domain/voice/usecases/fetch_call_history_use_case.dart"
    "lib/domain/todos/usecases/create_todo_use_case.dart"
    "lib/data/auth/repositories/auth_repository_impl.dart"
    "lib/data/fax/repositories/fax_repository_impl.dart"
    "lib/data/sms/repositories/sms_repository_impl.dart"
    "lib/data/todos/repositories/todo_repository_impl.dart"
    "lib/data/voice/repositories/voice_repository_impl.dart"
    "lib/features/auth/controllers/auth_controller.dart"
    "lib/features/fax/controllers/fax_controller.dart"
    "lib/features/home/controllers/home_controller.dart"
    "lib/features/sms/controllers/sms_controller.dart"
    "lib/features/todos/controllers/todos_controller.dart"
    "lib/features/voice/controllers/voice_controller.dart"
    "lib/features/auth/binding/auth_binding.dart"
    "lib/features/fax/binding/fax_binding.dart"
    "lib/features/home/binding/home_binding.dart"
    "lib/features/sms/binding/sms_binding.dart"
    "lib/features/todos/binding/todos_binding.dart"
    "lib/features/voice/binding/voice_binding.dart"
    "lib/theme/theme_binding.dart"
    "lib/theme/app_theme.dart"
    "lib/util/app_routes.dart"
    "pubspec.yaml"
    "analysis_options.yaml"
    "test/app_test.dart"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file (missing)"
    fi
done

echo ""
echo "Checking for key implementations..."

if grep -q "fenix: true" lib/features/auth/binding/auth_binding.dart && \
   grep -q "fenix: true" lib/features/todos/binding/todos_binding.dart; then
    echo "✓ fenix: true in feature bindings"
else
    echo "✗ fenix: true in feature bindings"
fi

if grep -q "extends BaseController" lib/features/auth/controllers/auth_controller.dart && \
   grep -q "extends BaseController" lib/features/todos/controllers/todos_controller.dart; then
    echo "✓ Controllers extend BaseController"
else
    echo "✗ Controllers extend BaseController"
fi

echo ""
echo "Verification complete!"
