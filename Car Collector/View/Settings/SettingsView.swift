//
//  SettingsView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/16/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var isDarkMode = false
    @State private var currentUser: User?
    @State private var showSignInOptions = false
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Settings")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Customize your experience")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 0) {
                            if let user = currentUser {
                                // Signed In View
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        // Profile Icon
                                        ZStack {
                                            Circle()
                                                .fill(Color(.systemGray6))
                                                .frame(width: 60, height: 60)
                                            
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 28))
                                                .foregroundColor(.black)
                                        }
                                        
                                        // User Info
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(user.displayName ?? "User")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.primary)
                                            
                                            Text(user.email ?? "")
                                                .font(.system(size: 14))
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(16)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    
                                    // Sign Out Button
                                    Button(action: {
                                        showSignOutAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                                .font(.system(size: 18))
                                            Text("Sign Out")
                                                .font(.system(size: 16, weight: .semibold))
                                            Spacer()
                                        }
                                        .foregroundColor(.red)
                                        .padding(16)
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red.opacity(0.3), lineWidth: 1.5)
                                        )
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal, 24)
                            } else {
                                // Not Signed In View
                                Button(action: {
                                    showSignInOptions = true
                                }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "person.crop.circle")
                                            .font(.system(size: 24))
                                            .foregroundColor(.black)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Sign In")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(.primary)
                                            
                                            Text("Sync your collection across devices")
                                                .font(.system(size: 13))
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(16)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    .padding(.bottom, 32)
                    
                    // Appearance Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Appearance")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                        
                        HStack(spacing: 16) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Dark Mode")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Disabled")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $isDarkMode)
                                .labelsHidden()
                                .tint(.black)
                        }
                        .padding(16)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 0) {
                            SettingsRow(icon: "info.circle", title: "Version", value: "1.0.0")
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsRow(icon: "doc.text", title: "Privacy Policy", value: "")
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsRow(icon: "doc.plaintext", title: "Terms of Service", value: "")
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignInOptions) {
                SignInOptionsView(isPresented: $showSignInOptions, onSignIn: { user in
                    currentUser = user
                })
            }
            .alert(isPresented: $showSignOutAlert) {
                Alert(
                    title: Text("Sign Out"),
                    message: Text("Are you sure you want to sign out?"),
                    primaryButton: .destructive(Text("Sign Out")) {
                        signOut()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                checkCurrentUser()
            }
        }
    }
    
    func checkCurrentUser() {
        currentUser = Auth.auth().currentUser
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            print("✅ User signed out successfully")
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }
}

// MARK: - Settings Row Component
struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Sign In Options View
struct SignInOptionsView: View {
    @Binding var isPresented: Bool
    var onSignIn: (User) -> Void
    @State private var showEmailSignIn = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Sign In")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Choose your preferred sign in method")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    // Apple Sign In
                    Button(action: {
                        // Apple Sign In will be implemented
                        print("Apple Sign In tapped")
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text("Continue with Apple")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                    }
                    
                    // Google Sign In
                    Button(action: {
                        // Google Sign In will be implemented
                        print("Google Sign In tapped")
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "g.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text("Continue with Google")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1.5)
                        )
                    }
                    
                    // Email Sign In
                    Button(action: {
                        showEmailSignIn = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text("Continue with Email")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1.5)
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Text("Your data will be synced securely across all your devices")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.primary)
                }
            }
            .sheet(isPresented: $showEmailSignIn) {
                EmailSignInView(isPresented: $showEmailSignIn, onSignIn: { user in
                    onSignIn(user)
                    isPresented = false
                })
            }
        }
    }
}

// MARK: - Email Sign In View
struct EmailSignInView: View {
    @Binding var isPresented: Bool
    var onSignIn: (User) -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text(isSignUp ? "Create Account" : "Welcome Back")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text(isSignUp ? "Sign up to sync your collection" : "Sign in to your account")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            TextField("Enter your email", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .padding(16)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            SecureField("Enter your password", text: $password)
                                .padding(16)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Error Message
                    if showError {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal, 24)
                    }
                    
                    // Sign In/Up Button
                    Button(action: {
                        handleAuth()
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(isSignUp ? "Sign Up" : "Sign In")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                    }
                    .disabled(email.isEmpty || password.isEmpty || isLoading)
                    .opacity((email.isEmpty || password.isEmpty || isLoading) ? 0.5 : 1.0)
                    .padding(.horizontal, 24)
                    
                    // Toggle Sign In/Up
                    Button(action: {
                        isSignUp.toggle()
                        showError = false
                    }) {
                        HStack(spacing: 4) {
                            Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                .foregroundColor(.secondary)
                            Text(isSignUp ? "Sign In" : "Sign Up")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                        .font(.system(size: 15))
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        isPresented = false
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    func handleAuth() {
        isLoading = true
        showError = false
        
        if isSignUp {
            // Sign Up
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                    print("❌ Sign up error: \(error.localizedDescription)")
                } else if let user = result?.user {
                    print("✅ User signed up successfully: \(user.email ?? "")")
                    onSignIn(user)
                    isPresented = false
                }
            }
        } else {
            // Sign In
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                    print("❌ Sign in error: \(error.localizedDescription)")
                } else if let user = result?.user {
                    print("✅ User signed in successfully: \(user.email ?? "")")
                    onSignIn(user)
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
