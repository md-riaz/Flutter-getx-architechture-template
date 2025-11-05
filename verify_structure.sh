#!/bin/bash

echo "Verifying Flutter GetX Architecture Structure..."
echo ""

# Check directory structure
echo "Checking directories..."
dirs=(
    "lib/base"
    "lib/binding"
    "lib/controller"
    "lib/features"
    "lib/features/auth/controllers"
    "lib/features/auth/models"
    "lib/features/auth/repositories"
    "lib/features/auth/screens"
    "lib/features/home/controllers"
    "lib/features/home/models"
    "lib/features/home/repositories"
    "lib/features/home/screens"
    "lib/helper"
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
    "lib/binding/initial_bindings.dart"
    "lib/binding/auth_binding.dart"
    "lib/binding/home_binding.dart"
    "lib/features/auth/controllers/auth_controller.dart"
    "lib/features/auth/models/user.dart"
    "lib/features/auth/repositories/auth_repository.dart"
    "lib/features/auth/screens/login_screen.dart"
    "lib/features/home/controllers/home_controller.dart"
    "lib/features/home/screens/home_screen.dart"
    "lib/services/auth_service.dart"
    "lib/services/feature_registry_service.dart"
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

# Check for fenix: true
if grep -q "fenix: true" lib/binding/auth_binding.dart && grep -q "fenix: true" lib/binding/home_binding.dart; then
    echo "✓ fenix: true in bindings"
else
    echo "✗ fenix: true in bindings"
fi

# Check for BaseController
if grep -q "extends BaseController" lib/features/auth/controllers/auth_controller.dart; then
    echo "✓ Controllers extend BaseController"
else
    echo "✗ Controllers extend BaseController"
fi

# Check for Timer
if grep -q "Timer" lib/features/auth/controllers/auth_controller.dart && grep -q "Timer" lib/features/home/controllers/home_controller.dart; then
    echo "✓ Random state via Timer"
else
    echo "✗ Random state via Timer"
fi

# Check for lifecycle prints
if grep -q "onInit called" lib/base/base_controller.dart && grep -q "onReady called" lib/base/base_controller.dart; then
    echo "✓ Lifecycle debug prints"
else
    echo "✗ Lifecycle debug prints"
fi

# Check for AuthRepository validation
if grep -q "validate" lib/features/auth/repositories/auth_repository.dart; then
    echo "✓ AuthRepository validate() method"
else
    echo "✗ AuthRepository validate() method"
fi

# Check for FeatureRegistryService
if grep -q "createFeatureBindings" lib/services/feature_registry_service.dart && grep -q "deleteFeatureBindings" lib/services/feature_registry_service.dart; then
    echo "✓ FeatureRegistryService with create/delete bindings"
else
    echo "✗ FeatureRegistryService with create/delete bindings"
fi

# Check for permanent services
if grep -q "permanent: true" lib/binding/initial_bindings.dart; then
    echo "✓ Permanent services via bindings"
else
    echo "✗ Permanent services via bindings"
fi

echo ""
echo "Verification complete!"
