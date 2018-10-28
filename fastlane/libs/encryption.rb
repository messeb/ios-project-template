require 'openssl'

# Encrypts all files of a folder
#
# @param folder Folder of the certificate and provisioning profile
# @param key Encryption key for the certificate and provisioning profile
def encrypt(folder, key)
  Dir.each_child(folder) do | child |
    unless File.extname(child) != ".enc"
      next
    end

    cipher = OpenSSL::Cipher::AES256.new :CBC
    cipher.encrypt
    cipher.key = Digest::SHA256.digest key

    file = File.absolute_path(child, folder)
    content = File.open(file, "rb").read

    encrypted_content = cipher.update(content) + cipher.final

    output_file = File.absolute_path(child + ".enc", folder)
    File.open(output_file, "w").write(encrypted_content)
  end
end

# Decrypts all files of a folder
#
# @param folder Folder of the certificate and provisioning profile
# @param key Decryption key for the certificate and provisioning profile
def decrypt(folder, key)
  Dir.each_child(folder) do | child |
    unless File.extname(child) == ".enc"
      next
    end

    puts child
    decipher = OpenSSL::Cipher::AES256.new :CBC
    decipher.decrypt
    decipher.key = Digest::SHA256.digest key

    file = File.absolute_path(child, folder)
    content = File.open(file, "rb").read

    decrypted_content = decipher.update(content) + decipher.final

    output_file_path = File.absolute_path(File.basename(child, ".enc"), folder)
    output_file = File.open(output_file_path, "w")
    output_file.sync = true
    output_file.write(decrypted_content)
  end
end
